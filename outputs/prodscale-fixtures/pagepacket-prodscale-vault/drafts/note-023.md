# note 023

Owner: sanitized-owner-353@example.test
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
pagepacket-cli snapshot . drafts/note-023.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-353-000 token-353-001 token-353-002 token-353-003 token-353-004 token-353-005 token-353-006 token-353-007 token-353-008 token-353-009 token-353-010 token-353-011 token-353-012 token-353-013 token-353-014 token-353-015 token-353-016 token-353-017 token-353-018 token-353-019 token-353-020 token-353-021 token-353-022 token-353-023 token-353-024 token-353-025 token-353-026 token-353-027 token-353-028 token-353-029 token-353-030 token-353-031 token-353-032 token-353-033 token-353-034 token-353-035 token-353-036 token-353-037 token-353-038 token-353-039 token-353-040 token-353-041 token-353-042 token-353-043 token-353-044 token-353-045 token-353-046 token-353-047
