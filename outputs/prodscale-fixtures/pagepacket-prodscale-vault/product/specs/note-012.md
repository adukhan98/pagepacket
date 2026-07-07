# note 012

Owner: sanitized-owner-012@example.test
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
pagepacket-cli snapshot . product/specs/note-012.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-012-000 token-012-001 token-012-002 token-012-003 token-012-004 token-012-005 token-012-006 token-012-007 token-012-008 token-012-009 token-012-010 token-012-011 token-012-012 token-012-013 token-012-014 token-012-015 token-012-016 token-012-017 token-012-018 token-012-019 token-012-020 token-012-021 token-012-022 token-012-023 token-012-024 token-012-025 token-012-026 token-012-027 token-012-028 token-012-029 token-012-030 token-012-031 token-012-032 token-012-033 token-012-034 token-012-035 token-012-036 token-012-037 token-012-038 token-012-039 token-012-040 token-012-041 token-012-042 token-012-043 token-012-044 token-012-045 token-012-046 token-012-047
