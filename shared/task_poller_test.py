#!/usr/bin/env python3
import json
import subprocess
import time
from pathlib import Path

DB = ["docker", "exec", "supabase-db", "psql", "-U", "postgres", "-d", "postgres", "-Atqc"]


def q(sql: str) -> str:
    out = subprocess.check_output(DB + [sql], text=True)
    return out.strip()


def lease_next(claimer: str):
    sql = f"select row_to_json(t) from public.lease_next_task('{claimer}', 30) as t;"
    out = q(sql)
    if not out:
        return None
    return json.loads(out)


def complete_task(task_id: str, actor: str, summary: str):
    safe_summary = summary.replace("'", "''")
    q(f"select public.complete_task('{task_id}'::uuid, '{actor}', '{safe_summary}');")


def queue_count() -> int:
    return int(q("select count(*) from public.task_queue;"))


def active_snapshot():
    sql = "select coalesce(json_agg(x), '[]'::json) from (select t.slug, q.status, q.leased_by from public.task_queue q join public.tasks t on t.id=q.task_id order by q.created_at) x;"
    return q(sql)


def task_snapshot():
    sql = "select coalesce(json_agg(x), '[]'::json) from (select slug, status from public.tasks order by created_at) x;"
    return q(sql)


def main():
    history = []
    idle_polls = 0
    while True:
        remaining = queue_count()
        history.append({"event": "queue_count", "remaining": remaining, "queue": json.loads(active_snapshot()), "tasks": json.loads(task_snapshot())})
        if remaining == 0:
            break

        leased = lease_next("openclaw-poller-test")
        if leased is None:
            idle_polls += 1
            history.append({"event": "no_lease", "idle_polls": idle_polls})
            if idle_polls >= 3:
                raise RuntimeError("Queue not empty but no task could be leased repeatedly")
            time.sleep(1.0)
            continue

        idle_polls = 0
        history.append({"event": "leased", "task": leased})
        time.sleep(0.2)
        complete_task(leased["task_id"], "openclaw-poller-test", f"Completed {leased['slug']} in polling test")
        history.append({"event": "completed", "task_id": leased["task_id"], "slug": leased["slug"]})
        time.sleep(0.2)

    Path("/home/jimmy/.openclaw/workspace/service-os-repo/shared/task-polling-test-result.json").write_text(json.dumps(history, indent=2), encoding="utf-8")
    print(json.dumps(history, indent=2))


if __name__ == "__main__":
    main()
