
<Box
  sx={{
    display: "grid",
    gridTemplateColumns: "1fr 1fr",
    gap: 3,

    "@media (max-width:900px)": {
      gridTemplateColumns: "1fr",
    },
  }}
>
  <Autocomplete
    multiple
    disableCloseOnSelect
    options={issueList}
    value={selectedIssues}
    onChange={(event, newValue) =>
      setSelectedIssues(newValue)
    }
    getOptionLabel={(option) =>
      option.issueCategoryName || ""
    }
    renderOption={(props, option, { selected }) => (
      <li {...props}>
        <Checkbox
          checked={selected}
          size="small"
        />
        {option.issueCategoryName}
      </li>
    )}
    renderInput={(params) => (
      <TextField
        {...params}
        label="Issues *"
        placeholder="Search Issues"
      />
    )}
  />

  <TextField
    fullWidth
    label="Add Issue"
    value={customIssues[0] || ""}
    onChange={(e) =>
      setCustomIssues([e.target.value])
    }
  />
</Box>