# note 010

Owner: sanitized-owner-070@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-010.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-070-000 token-070-001 token-070-002 token-070-003 token-070-004 token-070-005 token-070-006 token-070-007 token-070-008 token-070-009 token-070-010 token-070-011 token-070-012 token-070-013 token-070-014 token-070-015 token-070-016 token-070-017 token-070-018 token-070-019 token-070-020 token-070-021 token-070-022 token-070-023 token-070-024 token-070-025 token-070-026 token-070-027 token-070-028 token-070-029 token-070-030 token-070-031 token-070-032 token-070-033 token-070-034 token-070-035 token-070-036 token-070-037 token-070-038 token-070-039 token-070-040 token-070-041 token-070-042 token-070-043 token-070-044 token-070-045 token-070-046 token-070-047
