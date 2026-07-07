# note 001

Owner: sanitized-owner-091@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-001.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-091-000 token-091-001 token-091-002 token-091-003 token-091-004 token-091-005 token-091-006 token-091-007 token-091-008 token-091-009 token-091-010 token-091-011 token-091-012 token-091-013 token-091-014 token-091-015 token-091-016 token-091-017 token-091-018 token-091-019 token-091-020 token-091-021 token-091-022 token-091-023 token-091-024 token-091-025 token-091-026 token-091-027 token-091-028 token-091-029 token-091-030 token-091-031 token-091-032 token-091-033 token-091-034 token-091-035 token-091-036 token-091-037 token-091-038 token-091-039 token-091-040 token-091-041 token-091-042 token-091-043 token-091-044 token-091-045 token-091-046 token-091-047
