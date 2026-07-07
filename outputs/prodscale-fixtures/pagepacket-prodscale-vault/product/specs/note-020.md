# note 020

Owner: sanitized-owner-020@example.test
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
pagepacket-cli snapshot . product/specs/note-020.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-020-000 token-020-001 token-020-002 token-020-003 token-020-004 token-020-005 token-020-006 token-020-007 token-020-008 token-020-009 token-020-010 token-020-011 token-020-012 token-020-013 token-020-014 token-020-015 token-020-016 token-020-017 token-020-018 token-020-019 token-020-020 token-020-021 token-020-022 token-020-023 token-020-024 token-020-025 token-020-026 token-020-027 token-020-028 token-020-029 token-020-030 token-020-031 token-020-032 token-020-033 token-020-034 token-020-035 token-020-036 token-020-037 token-020-038 token-020-039 token-020-040 token-020-041 token-020-042 token-020-043 token-020-044 token-020-045 token-020-046 token-020-047
