# note 025

Owner: sanitized-owner-025@example.test
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
pagepacket-cli snapshot . product/specs/note-025.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-025-000 token-025-001 token-025-002 token-025-003 token-025-004 token-025-005 token-025-006 token-025-007 token-025-008 token-025-009 token-025-010 token-025-011 token-025-012 token-025-013 token-025-014 token-025-015 token-025-016 token-025-017 token-025-018 token-025-019 token-025-020 token-025-021 token-025-022 token-025-023 token-025-024 token-025-025 token-025-026 token-025-027 token-025-028 token-025-029 token-025-030 token-025-031 token-025-032 token-025-033 token-025-034 token-025-035 token-025-036 token-025-037 token-025-038 token-025-039 token-025-040 token-025-041 token-025-042 token-025-043 token-025-044 token-025-045 token-025-046 token-025-047
