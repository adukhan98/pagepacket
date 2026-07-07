# note 021

Owner: sanitized-owner-111@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-021.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-111-000 token-111-001 token-111-002 token-111-003 token-111-004 token-111-005 token-111-006 token-111-007 token-111-008 token-111-009 token-111-010 token-111-011 token-111-012 token-111-013 token-111-014 token-111-015 token-111-016 token-111-017 token-111-018 token-111-019 token-111-020 token-111-021 token-111-022 token-111-023 token-111-024 token-111-025 token-111-026 token-111-027 token-111-028 token-111-029 token-111-030 token-111-031 token-111-032 token-111-033 token-111-034 token-111-035 token-111-036 token-111-037 token-111-038 token-111-039 token-111-040 token-111-041 token-111-042 token-111-043 token-111-044 token-111-045 token-111-046 token-111-047
