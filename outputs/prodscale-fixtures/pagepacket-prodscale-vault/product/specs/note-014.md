# note 014

Owner: sanitized-owner-014@example.test
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
pagepacket-cli snapshot . product/specs/note-014.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-014-000 token-014-001 token-014-002 token-014-003 token-014-004 token-014-005 token-014-006 token-014-007 token-014-008 token-014-009 token-014-010 token-014-011 token-014-012 token-014-013 token-014-014 token-014-015 token-014-016 token-014-017 token-014-018 token-014-019 token-014-020 token-014-021 token-014-022 token-014-023 token-014-024 token-014-025 token-014-026 token-014-027 token-014-028 token-014-029 token-014-030 token-014-031 token-014-032 token-014-033 token-014-034 token-014-035 token-014-036 token-014-037 token-014-038 token-014-039 token-014-040 token-014-041 token-014-042 token-014-043 token-014-044 token-014-045 token-014-046 token-014-047
