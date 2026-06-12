const [issueList, setIssueList] = useState([]);
const [selectedIssues, setSelectedIssues] = useState([]);
const [customIssues, setCustomIssues] = useState([""]);

import Autocomplete from "@mui/material/Autocomplete";
import Checkbox from "@mui/material/Checkbox";


if (name === "categoryId") {

  const selectedCategory =
    voucherCategories.find(
      (item) => item.id === value
    );

  setIssueList(
    selectedCategory?.issueCategories || []
  );

  setSelectedIssues([]);
  setCustomIssues([""]);
}



<Box sx={{ display: "flex", flexDirection: "column", gap: 2 }}>

  <Autocomplete
    multiple
    options={issueList}
    value={selectedIssues}
    onChange={(event, newValue) =>
      setSelectedIssues(newValue)
    }
    disableCloseOnSelect
    getOptionLabel={(option) =>
      option.issueName || ""
    }
    renderOption={(props, option, { selected }) => (
      <li {...props}>
        <Checkbox
          checked={selected}
          size="small"
        />
        {option.issueName}
      </li>
    )}
    renderInput={(params) => (
      <TextField
        {...params}
        label="Issues *"
      />
    )}
  />

</Box>