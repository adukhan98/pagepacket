# note 004

Owner: sanitized-owner-094@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-004.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-094-000 token-094-001 token-094-002 token-094-003 token-094-004 token-094-005 token-094-006 token-094-007 token-094-008 token-094-009 token-094-010 token-094-011 token-094-012 token-094-013 token-094-014 token-094-015 token-094-016 token-094-017 token-094-018 token-094-019 token-094-020 token-094-021 token-094-022 token-094-023 token-094-024 token-094-025 token-094-026 token-094-027 token-094-028 token-094-029 token-094-030 token-094-031 token-094-032 token-094-033 token-094-034 token-094-035 token-094-036 token-094-037 token-094-038 token-094-039 token-094-040 token-094-041 token-094-042 token-094-043 token-094-044 token-094-045 token-094-046 token-094-047
