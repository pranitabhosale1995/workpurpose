
import Chip from "@mui/material/Chip";
import AddIcon from "@mui/icons-material/Add";


const [showCustomIssue, setShowCustomIssue] =
  useState(false);

const [customIssueInput, setCustomIssueInput] =
  useState("");

const [customIssues, setCustomIssues] =
  useState([]);

{showCustomIssue && (
  <Box sx={{ mt: 2 }}>

    <Typography
      variant="subtitle2"
      sx={{ mb: 1 }}
    >
      Custom Issues
    </Typography>

    <Box
      sx={{
        display: "flex",
        gap: 1,
        alignItems: "center",
      }}
    >
      <TextField
        fullWidth
        size="small"
        label="Enter New Issue"
        value={customIssueInput}
        onChange={(e) =>
          setCustomIssueInput(
            e.target.value
          )
        }
      />

      <Button
        variant="contained"
        startIcon={<AddIcon />}
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

          setCustomIssueInput("");
        }}
      >
        Add
      </Button>
    </Box>

    {customIssues.length >
      0 && (
        <Box
          sx={{
            mt: 2,
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
              <Chip
                key={index}
                label={issue}
                onDelete={() =>
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
              />
            )
          )}
        </Box>
      )}
  </Box>
)}


if (addIssueClicked) {

  setShowCustomIssue(true);

  setSelectedIssues(
    newValue.filter(
      (item) =>
        item.id !==
        "ADD_NEW"
    )
  );

  return;
}


issueCategoryIds:
  selectedIssues.map(
    (item) => item.id
  ),

customIssueCategories:
  customIssues,

