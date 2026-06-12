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