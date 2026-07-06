# note 022

Owner: sanitized-owner-052@example.test
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
pagepacket-cli snapshot . product/research/note-022.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-052-000 token-052-001 token-052-002 token-052-003 token-052-004 token-052-005 token-052-006 token-052-007 token-052-008 token-052-009 token-052-010 token-052-011 token-052-012 token-052-013 token-052-014 token-052-015 token-052-016 token-052-017 token-052-018 token-052-019 token-052-020 token-052-021 token-052-022 token-052-023 token-052-024 token-052-025 token-052-026 token-052-027 token-052-028 token-052-029 token-052-030 token-052-031 token-052-032 token-052-033 token-052-034 token-052-035 token-052-036 token-052-037 token-052-038 token-052-039 token-052-040 token-052-041 token-052-042 token-052-043 token-052-044 token-052-045 token-052-046 token-052-047
