# note 001

Owner: sanitized-owner-301@example.test
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
pagepacket-cli snapshot . nested/very/deep/workspace/note-001.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-301-000 token-301-001 token-301-002 token-301-003 token-301-004 token-301-005 token-301-006 token-301-007 token-301-008 token-301-009 token-301-010 token-301-011 token-301-012 token-301-013 token-301-014 token-301-015 token-301-016 token-301-017 token-301-018 token-301-019 token-301-020 token-301-021 token-301-022 token-301-023 token-301-024 token-301-025 token-301-026 token-301-027 token-301-028 token-301-029 token-301-030 token-301-031 token-301-032 token-301-033 token-301-034 token-301-035 token-301-036 token-301-037 token-301-038 token-301-039 token-301-040 token-301-041 token-301-042 token-301-043 token-301-044 token-301-045 token-301-046 token-301-047
