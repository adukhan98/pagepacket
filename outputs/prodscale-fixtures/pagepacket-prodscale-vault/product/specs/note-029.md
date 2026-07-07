# note 029

Owner: sanitized-owner-029@example.test
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
pagepacket-cli snapshot . product/specs/note-029.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-029-000 token-029-001 token-029-002 token-029-003 token-029-004 token-029-005 token-029-006 token-029-007 token-029-008 token-029-009 token-029-010 token-029-011 token-029-012 token-029-013 token-029-014 token-029-015 token-029-016 token-029-017 token-029-018 token-029-019 token-029-020 token-029-021 token-029-022 token-029-023 token-029-024 token-029-025 token-029-026 token-029-027 token-029-028 token-029-029 token-029-030 token-029-031 token-029-032 token-029-033 token-029-034 token-029-035 token-029-036 token-029-037 token-029-038 token-029-039 token-029-040 token-029-041 token-029-042 token-029-043 token-029-044 token-029-045 token-029-046 token-029-047
