# note 010

Owner: sanitized-owner-010@example.test
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
pagepacket-cli snapshot . product/specs/note-010.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-010-000 token-010-001 token-010-002 token-010-003 token-010-004 token-010-005 token-010-006 token-010-007 token-010-008 token-010-009 token-010-010 token-010-011 token-010-012 token-010-013 token-010-014 token-010-015 token-010-016 token-010-017 token-010-018 token-010-019 token-010-020 token-010-021 token-010-022 token-010-023 token-010-024 token-010-025 token-010-026 token-010-027 token-010-028 token-010-029 token-010-030 token-010-031 token-010-032 token-010-033 token-010-034 token-010-035 token-010-036 token-010-037 token-010-038 token-010-039 token-010-040 token-010-041 token-010-042 token-010-043 token-010-044 token-010-045 token-010-046 token-010-047
