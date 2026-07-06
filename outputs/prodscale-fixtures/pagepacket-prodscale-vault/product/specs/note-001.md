# note 001

Owner: sanitized-owner-001@example.test
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
pagepacket-cli snapshot . product/specs/note-001.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-001-000 token-001-001 token-001-002 token-001-003 token-001-004 token-001-005 token-001-006 token-001-007 token-001-008 token-001-009 token-001-010 token-001-011 token-001-012 token-001-013 token-001-014 token-001-015 token-001-016 token-001-017 token-001-018 token-001-019 token-001-020 token-001-021 token-001-022 token-001-023 token-001-024 token-001-025 token-001-026 token-001-027 token-001-028 token-001-029 token-001-030 token-001-031 token-001-032 token-001-033 token-001-034 token-001-035 token-001-036 token-001-037 token-001-038 token-001-039 token-001-040 token-001-041 token-001-042 token-001-043 token-001-044 token-001-045 token-001-046 token-001-047
