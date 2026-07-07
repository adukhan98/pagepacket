# note 008

Owner: sanitized-owner-068@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-008.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-068-000 token-068-001 token-068-002 token-068-003 token-068-004 token-068-005 token-068-006 token-068-007 token-068-008 token-068-009 token-068-010 token-068-011 token-068-012 token-068-013 token-068-014 token-068-015 token-068-016 token-068-017 token-068-018 token-068-019 token-068-020 token-068-021 token-068-022 token-068-023 token-068-024 token-068-025 token-068-026 token-068-027 token-068-028 token-068-029 token-068-030 token-068-031 token-068-032 token-068-033 token-068-034 token-068-035 token-068-036 token-068-037 token-068-038 token-068-039 token-068-040 token-068-041 token-068-042 token-068-043 token-068-044 token-068-045 token-068-046 token-068-047
