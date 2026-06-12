const [customIssueInput, setCustomIssueInput] =
  useState("");

{showCustomIssue && (
  <Box
    sx={{
      display: "flex",
      flexDirection: "column",
      gap: 1,
    }}
  >
    <Box
      sx={{
        display: "flex",
        gap: 1,
      }}
    >
      <TextField
        fullWidth
        label="Add Issue"
        value={customIssueInput}
        onChange={(e) =>
          setCustomIssueInput(
            e.target.value
          )
        }
      />

      <Button
        variant="contained"
        onClick={() => {
          if (
            !customIssueInput.trim()
          )
            return;

          setCustomIssues(
            (prev) => [
              ...prev,
              customIssueInput.trim(),
            ]
          );

          setCustomIssueInput(
            ""
          );
        }}
      >
        Add
      </Button>
    </Box>

    <Box
      sx={{
        display: "flex",
        flexWrap: "wrap",
        gap: 1,
      }}
    >
      {customIssues.map(
        (
          issue,
          index
        ) => (
          <Button
            key={index}
            size="small"
            variant="outlined"
            color="primary"
            onClick={() =>
              setCustomIssues(
                customIssues.filter(
                  (
                    _,
                    i
                  ) =>
                    i !==
                    index
                )
              )
            }
          >
            {issue} ✕
          </Button>
        )
      )}
    </Box>
  </Box>
)}




