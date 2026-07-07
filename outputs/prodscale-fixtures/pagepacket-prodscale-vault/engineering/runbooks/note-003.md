# note 003

Owner: sanitized-owner-093@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-003.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-093-000 token-093-001 token-093-002 token-093-003 token-093-004 token-093-005 token-093-006 token-093-007 token-093-008 token-093-009 token-093-010 token-093-011 token-093-012 token-093-013 token-093-014 token-093-015 token-093-016 token-093-017 token-093-018 token-093-019 token-093-020 token-093-021 token-093-022 token-093-023 token-093-024 token-093-025 token-093-026 token-093-027 token-093-028 token-093-029 token-093-030 token-093-031 token-093-032 token-093-033 token-093-034 token-093-035 token-093-036 token-093-037 token-093-038 token-093-039 token-093-040 token-093-041 token-093-042 token-093-043 token-093-044 token-093-045 token-093-046 token-093-047
