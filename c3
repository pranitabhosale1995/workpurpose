
<Autocomplete
  multiple
  disableCloseOnSelect
  options={[
    ...issueList,
    {
      id: "ADD_NEW",
      issueCategoryName: "+ Add Issue",
    },
  ]}
  value={selectedIssues}
  onChange={(event, newValue) => {

    const addIssueClicked =
      newValue.find(
        (item) => item.id === "ADD_NEW"
      );

    if (addIssueClicked) {
      setShowCustomIssue(true);

      setSelectedIssues(
        newValue.filter(
          (item) =>
            item.id !== "ADD_NEW"
        )
      );

      return;
    }

    setSelectedIssues(newValue);
  }}
  getOptionLabel={(option) =>
    option.issueCategoryName || ""
  }
  renderOption={(
    props,
    option,
    { selected }
  ) => (
    <li {...props}>
      {option.id !== "ADD_NEW" && (
        <Checkbox
          checked={selected}
          size="small"
        />
      )}

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



const [showCustomIssue, setShowCustomIssue] =
  useState(false);



{showCustomIssue && (
  <TextField
    fullWidth
    label="Add Issue"
    value={customIssues[0] || ""}
    onChange={(e) =>
      setCustomIssues([
        e.target.value,
      ])
    }
  />
)}






<Box
  sx={{
    display: "grid",
    gridTemplateColumns:
      showCustomIssue
        ? "1fr 1fr"
        : "1fr",
    gap: 3,

    "@media (max-width:900px)": {
      gridTemplateColumns: "1fr",
    },
  }}
>
  <Autocomplete
    multiple
    disableCloseOnSelect
    options={[
      ...issueList,
      {
        id: "ADD_NEW",
        issueCategoryName:
          "+ Add Issue",
      },
    ]}
    value={selectedIssues}
    onChange={(
      event,
      newValue
    ) => {
      const addIssueClicked =
        newValue.find(
          (item) =>
            item.id ===
            "ADD_NEW"
        );

      if (
        addIssueClicked
      ) {
        setShowCustomIssue(
          true
        );

        setSelectedIssues(
          newValue.filter(
            (item) =>
              item.id !==
              "ADD_NEW"
          )
        );

        return;
      }

      setSelectedIssues(
        newValue
      );
    }}
    getOptionLabel={(
      option
    ) =>
      option.issueCategoryName ||
      ""
    }
    renderOption={(
      props,
      option,
      { selected }
    ) => (
      <li {...props}>
        {option.id !==
          "ADD_NEW" && (
            <Checkbox
              checked={
                selected
              }
              size="small"
            />
          )}

        {
          option.issueCategoryName
        }
      </li>
    )}
    renderInput={(
      params
    ) => (
      <TextField
        {...params}
        label="Issues *"
        placeholder="Search Issues"
      />
    )}
  />

  {showCustomIssue && (
    <TextField
      fullWidth
      label="Add Issue"
      value={
        customIssues[0] ||
        ""
      }
      onChange={(e) =>
        setCustomIssues([
          e.target.value,
        ])
      }
    />
  )}
</Box>