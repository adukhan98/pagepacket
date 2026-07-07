# note 022

Owner: sanitized-owner-022@example.test
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
pagepacket-cli snapshot . product/specs/note-022.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-022-000 token-022-001 token-022-002 token-022-003 token-022-004 token-022-005 token-022-006 token-022-007 token-022-008 token-022-009 token-022-010 token-022-011 token-022-012 token-022-013 token-022-014 token-022-015 token-022-016 token-022-017 token-022-018 token-022-019 token-022-020 token-022-021 token-022-022 token-022-023 token-022-024 token-022-025 token-022-026 token-022-027 token-022-028 token-022-029 token-022-030 token-022-031 token-022-032 token-022-033 token-022-034 token-022-035 token-022-036 token-022-037 token-022-038 token-022-039 token-022-040 token-022-041 token-022-042 token-022-043 token-022-044 token-022-045 token-022-046 token-022-047
