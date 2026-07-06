# note 004

Owner: sanitized-owner-004@example.test
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
pagepacket-cli snapshot . product/specs/note-004.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-004-000 token-004-001 token-004-002 token-004-003 token-004-004 token-004-005 token-004-006 token-004-007 token-004-008 token-004-009 token-004-010 token-004-011 token-004-012 token-004-013 token-004-014 token-004-015 token-004-016 token-004-017 token-004-018 token-004-019 token-004-020 token-004-021 token-004-022 token-004-023 token-004-024 token-004-025 token-004-026 token-004-027 token-004-028 token-004-029 token-004-030 token-004-031 token-004-032 token-004-033 token-004-034 token-004-035 token-004-036 token-004-037 token-004-038 token-004-039 token-004-040 token-004-041 token-004-042 token-004-043 token-004-044 token-004-045 token-004-046 token-004-047
