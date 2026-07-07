# note 011

Owner: sanitized-owner-011@example.test
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
pagepacket-cli snapshot . product/specs/note-011.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-011-000 token-011-001 token-011-002 token-011-003 token-011-004 token-011-005 token-011-006 token-011-007 token-011-008 token-011-009 token-011-010 token-011-011 token-011-012 token-011-013 token-011-014 token-011-015 token-011-016 token-011-017 token-011-018 token-011-019 token-011-020 token-011-021 token-011-022 token-011-023 token-011-024 token-011-025 token-011-026 token-011-027 token-011-028 token-011-029 token-011-030 token-011-031 token-011-032 token-011-033 token-011-034 token-011-035 token-011-036 token-011-037 token-011-038 token-011-039 token-011-040 token-011-041 token-011-042 token-011-043 token-011-044 token-011-045 token-011-046 token-011-047
