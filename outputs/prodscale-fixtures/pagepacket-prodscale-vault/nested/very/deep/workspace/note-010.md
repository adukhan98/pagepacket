# note 010

Owner: sanitized-owner-310@example.test
Status: draft

This generated document is safe local test data for Pagepacket. It avoids customer, account, and production content.

## Summary

The file exercises Markdown editing, preview rendering, snapshot history, external-agent edits, and CLI traversal under a production-scale folder tree.

## Checklist

- [ ] Verify edit mode
- [x] Keep Markdown plain
- [ ] Review agent changes before accepting

## Table

| Area | State | Risk |
| --- | --- | --- |
| app | active | medium |
| cli | active | low |
| landing | preview | medium |

## Quote

> Human review remains the boundary before agent edits become canonical.

## Code

```sh
pagepacket-cli snapshot . nested/very/deep/workspace/note-010.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-310-000 token-310-001 token-310-002 token-310-003 token-310-004 token-310-005 token-310-006 token-310-007 token-310-008 token-310-009 token-310-010 token-310-011 token-310-012 token-310-013 token-310-014 token-310-015 token-310-016 token-310-017 token-310-018 token-310-019 token-310-020 token-310-021 token-310-022 token-310-023 token-310-024 token-310-025 token-310-026 token-310-027 token-310-028 token-310-029 token-310-030 token-310-031 token-310-032 token-310-033 token-310-034 token-310-035 token-310-036 token-310-037 token-310-038 token-310-039 token-310-040 token-310-041 token-310-042 token-310-043 token-310-044 token-310-045 token-310-046 token-310-047
