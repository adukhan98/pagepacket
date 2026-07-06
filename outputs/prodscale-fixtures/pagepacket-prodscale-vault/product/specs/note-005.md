# note 005

Owner: sanitized-owner-005@example.test
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
pagepacket-cli snapshot . product/specs/note-005.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-005-000 token-005-001 token-005-002 token-005-003 token-005-004 token-005-005 token-005-006 token-005-007 token-005-008 token-005-009 token-005-010 token-005-011 token-005-012 token-005-013 token-005-014 token-005-015 token-005-016 token-005-017 token-005-018 token-005-019 token-005-020 token-005-021 token-005-022 token-005-023 token-005-024 token-005-025 token-005-026 token-005-027 token-005-028 token-005-029 token-005-030 token-005-031 token-005-032 token-005-033 token-005-034 token-005-035 token-005-036 token-005-037 token-005-038 token-005-039 token-005-040 token-005-041 token-005-042 token-005-043 token-005-044 token-005-045 token-005-046 token-005-047
