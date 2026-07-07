# note 020

Owner: sanitized-owner-080@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-020.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-080-000 token-080-001 token-080-002 token-080-003 token-080-004 token-080-005 token-080-006 token-080-007 token-080-008 token-080-009 token-080-010 token-080-011 token-080-012 token-080-013 token-080-014 token-080-015 token-080-016 token-080-017 token-080-018 token-080-019 token-080-020 token-080-021 token-080-022 token-080-023 token-080-024 token-080-025 token-080-026 token-080-027 token-080-028 token-080-029 token-080-030 token-080-031 token-080-032 token-080-033 token-080-034 token-080-035 token-080-036 token-080-037 token-080-038 token-080-039 token-080-040 token-080-041 token-080-042 token-080-043 token-080-044 token-080-045 token-080-046 token-080-047
