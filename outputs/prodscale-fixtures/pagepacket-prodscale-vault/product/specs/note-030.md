# note 030

Owner: sanitized-owner-030@example.test
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
pagepacket-cli snapshot . product/specs/note-030.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-030-000 token-030-001 token-030-002 token-030-003 token-030-004 token-030-005 token-030-006 token-030-007 token-030-008 token-030-009 token-030-010 token-030-011 token-030-012 token-030-013 token-030-014 token-030-015 token-030-016 token-030-017 token-030-018 token-030-019 token-030-020 token-030-021 token-030-022 token-030-023 token-030-024 token-030-025 token-030-026 token-030-027 token-030-028 token-030-029 token-030-030 token-030-031 token-030-032 token-030-033 token-030-034 token-030-035 token-030-036 token-030-037 token-030-038 token-030-039 token-030-040 token-030-041 token-030-042 token-030-043 token-030-044 token-030-045 token-030-046 token-030-047
