# note 030

Owner: sanitized-owner-330@example.test
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
pagepacket-cli snapshot . nested/very/deep/workspace/note-030.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-330-000 token-330-001 token-330-002 token-330-003 token-330-004 token-330-005 token-330-006 token-330-007 token-330-008 token-330-009 token-330-010 token-330-011 token-330-012 token-330-013 token-330-014 token-330-015 token-330-016 token-330-017 token-330-018 token-330-019 token-330-020 token-330-021 token-330-022 token-330-023 token-330-024 token-330-025 token-330-026 token-330-027 token-330-028 token-330-029 token-330-030 token-330-031 token-330-032 token-330-033 token-330-034 token-330-035 token-330-036 token-330-037 token-330-038 token-330-039 token-330-040 token-330-041 token-330-042 token-330-043 token-330-044 token-330-045 token-330-046 token-330-047
