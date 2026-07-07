# note 028

Owner: sanitized-owner-358@example.test
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
pagepacket-cli snapshot . drafts/note-028.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-358-000 token-358-001 token-358-002 token-358-003 token-358-004 token-358-005 token-358-006 token-358-007 token-358-008 token-358-009 token-358-010 token-358-011 token-358-012 token-358-013 token-358-014 token-358-015 token-358-016 token-358-017 token-358-018 token-358-019 token-358-020 token-358-021 token-358-022 token-358-023 token-358-024 token-358-025 token-358-026 token-358-027 token-358-028 token-358-029 token-358-030 token-358-031 token-358-032 token-358-033 token-358-034 token-358-035 token-358-036 token-358-037 token-358-038 token-358-039 token-358-040 token-358-041 token-358-042 token-358-043 token-358-044 token-358-045 token-358-046 token-358-047
