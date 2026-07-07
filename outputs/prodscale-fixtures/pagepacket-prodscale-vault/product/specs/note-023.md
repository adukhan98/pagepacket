# note 023

Owner: sanitized-owner-023@example.test
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
pagepacket-cli snapshot . product/specs/note-023.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-023-000 token-023-001 token-023-002 token-023-003 token-023-004 token-023-005 token-023-006 token-023-007 token-023-008 token-023-009 token-023-010 token-023-011 token-023-012 token-023-013 token-023-014 token-023-015 token-023-016 token-023-017 token-023-018 token-023-019 token-023-020 token-023-021 token-023-022 token-023-023 token-023-024 token-023-025 token-023-026 token-023-027 token-023-028 token-023-029 token-023-030 token-023-031 token-023-032 token-023-033 token-023-034 token-023-035 token-023-036 token-023-037 token-023-038 token-023-039 token-023-040 token-023-041 token-023-042 token-023-043 token-023-044 token-023-045 token-023-046 token-023-047
