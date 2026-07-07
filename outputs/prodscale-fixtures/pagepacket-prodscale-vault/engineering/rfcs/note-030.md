# note 030

Owner: sanitized-owner-090@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-030.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-090-000 token-090-001 token-090-002 token-090-003 token-090-004 token-090-005 token-090-006 token-090-007 token-090-008 token-090-009 token-090-010 token-090-011 token-090-012 token-090-013 token-090-014 token-090-015 token-090-016 token-090-017 token-090-018 token-090-019 token-090-020 token-090-021 token-090-022 token-090-023 token-090-024 token-090-025 token-090-026 token-090-027 token-090-028 token-090-029 token-090-030 token-090-031 token-090-032 token-090-033 token-090-034 token-090-035 token-090-036 token-090-037 token-090-038 token-090-039 token-090-040 token-090-041 token-090-042 token-090-043 token-090-044 token-090-045 token-090-046 token-090-047
