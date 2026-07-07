# note 020

Owner: sanitized-owner-050@example.test
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
pagepacket-cli snapshot . product/research/note-020.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-050-000 token-050-001 token-050-002 token-050-003 token-050-004 token-050-005 token-050-006 token-050-007 token-050-008 token-050-009 token-050-010 token-050-011 token-050-012 token-050-013 token-050-014 token-050-015 token-050-016 token-050-017 token-050-018 token-050-019 token-050-020 token-050-021 token-050-022 token-050-023 token-050-024 token-050-025 token-050-026 token-050-027 token-050-028 token-050-029 token-050-030 token-050-031 token-050-032 token-050-033 token-050-034 token-050-035 token-050-036 token-050-037 token-050-038 token-050-039 token-050-040 token-050-041 token-050-042 token-050-043 token-050-044 token-050-045 token-050-046 token-050-047
