# note 017

Owner: sanitized-owner-017@example.test
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
pagepacket-cli snapshot . product/specs/note-017.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-017-000 token-017-001 token-017-002 token-017-003 token-017-004 token-017-005 token-017-006 token-017-007 token-017-008 token-017-009 token-017-010 token-017-011 token-017-012 token-017-013 token-017-014 token-017-015 token-017-016 token-017-017 token-017-018 token-017-019 token-017-020 token-017-021 token-017-022 token-017-023 token-017-024 token-017-025 token-017-026 token-017-027 token-017-028 token-017-029 token-017-030 token-017-031 token-017-032 token-017-033 token-017-034 token-017-035 token-017-036 token-017-037 token-017-038 token-017-039 token-017-040 token-017-041 token-017-042 token-017-043 token-017-044 token-017-045 token-017-046 token-017-047
