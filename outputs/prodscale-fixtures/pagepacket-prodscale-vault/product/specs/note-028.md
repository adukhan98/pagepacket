# note 028

Owner: sanitized-owner-028@example.test
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
pagepacket-cli snapshot . product/specs/note-028.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-028-000 token-028-001 token-028-002 token-028-003 token-028-004 token-028-005 token-028-006 token-028-007 token-028-008 token-028-009 token-028-010 token-028-011 token-028-012 token-028-013 token-028-014 token-028-015 token-028-016 token-028-017 token-028-018 token-028-019 token-028-020 token-028-021 token-028-022 token-028-023 token-028-024 token-028-025 token-028-026 token-028-027 token-028-028 token-028-029 token-028-030 token-028-031 token-028-032 token-028-033 token-028-034 token-028-035 token-028-036 token-028-037 token-028-038 token-028-039 token-028-040 token-028-041 token-028-042 token-028-043 token-028-044 token-028-045 token-028-046 token-028-047
