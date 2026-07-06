# note 017

Owner: sanitized-owner-077@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-017.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-077-000 token-077-001 token-077-002 token-077-003 token-077-004 token-077-005 token-077-006 token-077-007 token-077-008 token-077-009 token-077-010 token-077-011 token-077-012 token-077-013 token-077-014 token-077-015 token-077-016 token-077-017 token-077-018 token-077-019 token-077-020 token-077-021 token-077-022 token-077-023 token-077-024 token-077-025 token-077-026 token-077-027 token-077-028 token-077-029 token-077-030 token-077-031 token-077-032 token-077-033 token-077-034 token-077-035 token-077-036 token-077-037 token-077-038 token-077-039 token-077-040 token-077-041 token-077-042 token-077-043 token-077-044 token-077-045 token-077-046 token-077-047
