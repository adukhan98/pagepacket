# note 027

Owner: sanitized-owner-087@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-027.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-087-000 token-087-001 token-087-002 token-087-003 token-087-004 token-087-005 token-087-006 token-087-007 token-087-008 token-087-009 token-087-010 token-087-011 token-087-012 token-087-013 token-087-014 token-087-015 token-087-016 token-087-017 token-087-018 token-087-019 token-087-020 token-087-021 token-087-022 token-087-023 token-087-024 token-087-025 token-087-026 token-087-027 token-087-028 token-087-029 token-087-030 token-087-031 token-087-032 token-087-033 token-087-034 token-087-035 token-087-036 token-087-037 token-087-038 token-087-039 token-087-040 token-087-041 token-087-042 token-087-043 token-087-044 token-087-045 token-087-046 token-087-047
