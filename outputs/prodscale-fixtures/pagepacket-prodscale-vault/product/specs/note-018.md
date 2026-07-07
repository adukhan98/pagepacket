# note 018

Owner: sanitized-owner-018@example.test
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
pagepacket-cli snapshot . product/specs/note-018.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-018-000 token-018-001 token-018-002 token-018-003 token-018-004 token-018-005 token-018-006 token-018-007 token-018-008 token-018-009 token-018-010 token-018-011 token-018-012 token-018-013 token-018-014 token-018-015 token-018-016 token-018-017 token-018-018 token-018-019 token-018-020 token-018-021 token-018-022 token-018-023 token-018-024 token-018-025 token-018-026 token-018-027 token-018-028 token-018-029 token-018-030 token-018-031 token-018-032 token-018-033 token-018-034 token-018-035 token-018-036 token-018-037 token-018-038 token-018-039 token-018-040 token-018-041 token-018-042 token-018-043 token-018-044 token-018-045 token-018-046 token-018-047
