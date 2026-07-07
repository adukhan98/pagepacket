# note 029

Owner: sanitized-owner-359@example.test
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
pagepacket-cli snapshot . drafts/note-029.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-359-000 token-359-001 token-359-002 token-359-003 token-359-004 token-359-005 token-359-006 token-359-007 token-359-008 token-359-009 token-359-010 token-359-011 token-359-012 token-359-013 token-359-014 token-359-015 token-359-016 token-359-017 token-359-018 token-359-019 token-359-020 token-359-021 token-359-022 token-359-023 token-359-024 token-359-025 token-359-026 token-359-027 token-359-028 token-359-029 token-359-030 token-359-031 token-359-032 token-359-033 token-359-034 token-359-035 token-359-036 token-359-037 token-359-038 token-359-039 token-359-040 token-359-041 token-359-042 token-359-043 token-359-044 token-359-045 token-359-046 token-359-047
