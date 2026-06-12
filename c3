
import React, { useEffect, useState } from "react";
import { useSelector } from "react-redux";
import {
  Alert,
  Box,
  Button,
  Card,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  FormControl,
  FormHelperText,
  IconButton,
  InputLabel,
  MenuItem,
  Select,
  Snackbar,
  TextField,
  Typography,
  Checkbox,
  Autocomplete,
  Chip
} from "@mui/material";

import ContentCopyIcon from "@mui/icons-material/ContentCopy";
import AddIcon from "@mui/icons-material/Add";

import { useNavigate } from "react-router-dom";

import useApi from "../../hooks/useApi";

import ViewVoucherRequestScreen from "./ViewVoucherRequestScreen";

const RequestVoucherScreen = () => {

 const [showCustomIssue, setShowCustomIssue] =
  useState(false);

const [customIssueInput, setCustomIssueInput] =
  useState("");

const [customIssues, setCustomIssues] =
  useState([]);

const [issueList , setIssueList ] =
  useState([]);
const [selectedIssues  , setSelectedIssues  ] =
  useState([]);

const [issueOpen  , setIssueOpen  ] =
  useState(false);


  const { user } = useSelector((state) => state.auth);

  const navigate = useNavigate();

  const { callApi } = useApi();

  const [currentScreen, setCurrentScreen] =
    useState("request");

  const [voucherCategories, setVoucherCategories] =
    useState([]);

  const [roles, setRoles] =
    useState([]);

  const [loading, setLoading] =
    useState(false);

  const [roleLoading, setRoleLoading] =
    useState(false);

  const [openDialog, setOpenDialog] =
    useState(false);

  const [createdVID, setCreatedVID] =
    useState("");

  const [errors, setErrors] =
    useState({});

  const [snackbar, setSnackbar] =
    useState({
      open: false,
      message: "",
      severity: "success",
    });

  const [formData, setFormData] =
    useState({
      categoryId: "",
      otherCategory: "",
      description: "",
      roleId: "",
      sdRequestNumber: "",
    });

  useEffect(() => {
    fetchRoles();
    fetchVoucherCategories();
  }, []);

  const fetchVoucherCategories =
    async () => {
      try {
        const response = await callApi(
          "/VE/voucher-transactions/voucher-categories",
          null,
          "GET"
        );

        console.log(
          "Voucher Categories Response =>",
          response
        );

        const categories =
          Array.isArray(response)
            ? response
            : response?.data || [];

        setVoucherCategories(
          categories
        );
      } catch (error) {
        console.error(
          "Category API Error =>",
          error
        );

        setVoucherCategories([]);
      }
    };

  const fetchRoles = async () => {
    setRoleLoading(true);

    try {
      const response = await callApi(
        "/VE/voucher-transactions/allowed-roles?menuId=30",
        null,
        "GET"
      );

      console.log(
        "Allowed Roles Response =>",
        response
      );

      setRoles(
        Array.isArray(response.data)
          ? response.data
          : []
      );
    } catch (error) {
      console.error(
        "Failed to fetch roles",
        error
      );

      setSnackbar({
        open: true,
        message: "Failed to load roles",
        severity: "error",
      });
    } finally {
      setRoleLoading(false);
    }
  };


  const handleChange = (e) => {
    const { name, value } =
      e.target;

    if (
      name === "description" &&
      value.length > 500
    ) {
      return;
    }

    if (name === "otherCategory") {
      const regex =
        /^[A-Za-z0-9 -]*$/;

      if (!regex.test(value)) {
        return;
      }

      if (value.length > 20) {
        return;
      }
    }

    if (
      name === "sdRequestNumber"
    ) {
      const regex =
        /^[0-9,]*$/;

      if (!regex.test(value)) {
        return;
      }
    }

    if (name === "categoryId") {

      const selectedCategory =
        voucherCategories.find(
          (item) => item.id == value
        );
      console.log(
        "Selected Category =>",
        selectedCategory
      );

      console.log(
        "Issues =>",
        selectedCategory?.issueCategories
      );

      setIssueList(
        selectedCategory?.issueCategories || []
      );

      setSelectedIssues([]);
      setCustomIssues([""]);
    }


    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));

    setErrors((prev) => ({
      ...prev,
      [name]: "",
    }));
  };

  const validateForm = () => {
    let newErrors = {};

    if (!formData.categoryId) {
      newErrors.categoryId =
        "Voucher Category is required";
    }

    const selectedCategory =
      voucherCategories.find(
        (item) =>
          item.id ===
          formData.categoryId
      );

    if (
      selectedCategory?.categoryName ===
      "Other" &&
      !formData.otherCategory.trim()
    ) {
      newErrors.otherCategory =
        "Please enter other category";
    }

    if (
      !formData.description.trim()
    ) {
      newErrors.description =
        "Description is required";
    }

    if (
      formData.description.length >
      500
    ) {
      newErrors.description =
        "Maximum 500 Characters Allowed";
    }

    if (!formData.roleId) {
      newErrors.roleId =
        "Allowed Role is required";
    }

    setErrors(newErrors);

    return (
      Object.keys(newErrors)
        .length === 0
    );
  };

  const handleCreate =
    async () => {
      if (!validateForm()) {
        return;
      }

      setLoading(true);

      try {
        const selectedCategory =
          voucherCategories.find(
            (item) =>
              item.id ===
              formData.categoryId
          );

        const payload = {
          categoryId:
            formData.categoryId,

          customCategory:
            selectedCategory?.categoryName ===
              "Other"
              ? formData.otherCategory
              : "",

          description:
            formData.description,

          allowedRole:
            formData.roleId,

          sdReqNo:
            formData.sdRequestNumber,

          createdBy: user.userId,

          issueCategoryIds: selectedIssues.map(
            (item) => item.id
          ),

          
customIssueCategories:
  customIssues,


        };

        console.log(
          "Create Payload =>",
          JSON.stringify(payload, null, 2)
        );

        const response =
          await callApi(
            "/VE/voucher-transactions/create-vid",
            payload,
            "POST"
          );

        console.log(
          "Create Response =>",
          response
        );

        await fetchVoucherCategories();

        const createdVid =
          response?.vid ||
          response?.data?.vid ||
          "";

        setCreatedVID(
          createdVid
        );

        setOpenDialog(true);

        setSnackbar({
          open: true,
          message:
            "Voucher Request Created Successfully",
          severity:
            "success",
        });

        setFormData({
          categoryId: "",
          otherCategory: "",
          description: "",
          roleId: "",
          sdRequestNumber: "",

        });

        setErrors({});
      } catch (error) {
        console.error(
          "Create Voucher Error =>",
          error
        );

        setSnackbar({
          open: true,
          message:
            "Failed To Create Voucher",
          severity: "error",
        });
      } finally {
        setLoading(false);
      }
    };

  const handleReset = () => {
    setFormData({
      categoryId: "",
      otherCategory: "",
      description: "",
      roleId: "",
      sdRequestNumber: "",
    });

    setErrors({});
  };

  if (currentScreen === "view") {
    return (
      <ViewVoucherRequestScreen />
    );
  }

  return (
    <Box p={4}>
      <Card
        elevation={3}
        sx={{
          maxWidth: "1100px",
          margin: "40px auto",
          padding: 4,
          borderRadius: 3,
        }}
      >
        <Typography
          variant="h5"
          fontWeight={700}
          mb={4}
          color="primary"
        >
          Request Voucher
        </Typography>

        <Box
          sx={{
            width: "100%",
            display: "flex",
            flexDirection:
              "column",
            gap: 3,
          }}
        >
          {/* Voucher Category + Other */}
          <Box
            sx={{
              display: "grid",
              gridTemplateColumns:
                voucherCategories.find(
                  (item) =>
                    item.id ===
                    formData.categoryId &&
                    item.categoryName ===
                    "Other"
                )
                  ? "1fr 1fr"
                  : "1fr",

              gap: 3,

              "@media (max-width:900px)":
              {
                gridTemplateColumns:
                  "1fr",
              },
            }}
          >
            {/* Voucher Category */}
            <FormControl
              fullWidth
              error={
                !!errors.categoryId
              }
            >
              <InputLabel>
                Voucher Category
              </InputLabel>

              <Select
                disabled={loading}
                name="categoryId"
                value={
                  formData.categoryId
                }
                onChange={
                  handleChange
                }
                label="Voucher Category"
              >
                <MenuItem value="">
                  <em>
                    Select Category
                  </em>
                </MenuItem>

                {voucherCategories?.map(
                  (item) => (
                    <MenuItem
                      key={item.id}
                      value={item.id}
                    >
                      {
                        item.categoryName
                      }
                    </MenuItem>
                  )
                )}
              </Select>

              <FormHelperText>
                {
                  errors.categoryId
                }
              </FormHelperText>
            </FormControl>

            {/* Other Category */}
            {voucherCategories.find(
              (item) =>
                item.id ===
                formData.categoryId &&
                item.categoryName ===
                "Other"
            ) && (
                <TextField
                  disabled={loading}
                  fullWidth
                  label="Other Category"
                  name="otherCategory"
                  value={
                    formData.otherCategory
                  }
                  onChange={
                    handleChange
                  }
                  error={
                    !!errors.otherCategory
                  }
                  inputProps={{
                    maxLength: 20,
                  }}
                  helperText={
                    errors.otherCategory
                      ? errors.otherCategory
                      : `${formData.otherCategory.length}/20`
                  }
                />
              )}
          </Box>

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

     open={issueOpen}
  onOpen={() => setIssueOpen(true)}
  onClose={() => setIssueOpen(false)}

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

     
if (addIssueClicked) {
  setShowCustomIssue(true);
  setIssueOpen(false);

  setSelectedIssues(
    newValue.filter(
      (item) => item.id !== "ADD_NEW"
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
  <Box >

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
</Box>


          {/* Allowed Role + SD */}
          <Box
            sx={{
              display: "grid",
              gridTemplateColumns:
                "1fr 1fr",
              gap: 3,

              "@media (max-width:900px)":
              {
                gridTemplateColumns:
                  "1fr",
              },
            }}
          >
            {/* Role */}
            <FormControl
              fullWidth
              error={
                !!errors.roleId
              }
            >
              <InputLabel>
                Allowed Role
              </InputLabel>
              <Select
                disabled={loading || roleLoading}
                name="roleId"
                value={formData.roleId}
                label="Allowed Role"
                onChange={handleChange}
              >
                <MenuItem value="">
                  <em>Select Role</em>
                </MenuItem>

                {roles?.map((role) => (
                  <MenuItem
                    key={role.roleId}
                    value={role.roleId}
                  >
                    {role.roleName}
                  </MenuItem>
                ))}
              </Select>


              <FormHelperText>
                {errors.roleId}
              </FormHelperText>
            </FormControl>

            {/* SD */}
            <TextField
              disabled={loading}
              fullWidth
              label="SD Request Number"
              name="sdRequestNumber"
              value={
                formData.sdRequestNumber
              }
              onChange={
                handleChange
              }
              helperText="Only numbers and commas allowed"
            />
          </Box>

          {/* Description */}
          <TextField
            disabled={loading}
            fullWidth
            multiline
            rows={5}
            label="Description"
            name="description"
            value={
              formData.description
            }
            onChange={
              handleChange
            }
            error={
              !!errors.description
            }
            inputProps={{
              maxLength: 500,
            }}
            helperText={
              errors.description
                ? errors.description
                : `${formData.description.length}/500`
            }
          />

          {/* Buttons */}
          <Box
            sx={{
              display: "flex",
              justifyContent:
                "flex-end",
              gap: 2,
            }}
          >
            <Button
              variant="outlined"
              onClick={
                handleReset
              }
              disabled={loading}
              sx={{
                minWidth:
                  "120px",
                textTransform:
                  "none",
                borderRadius:
                  "8px",
              }}
            >
              Reset
            </Button>

            <Button
              variant="contained"
              onClick={
                handleCreate
              }
              disabled={loading}
              sx={{
                minWidth:
                  "120px",
                textTransform:
                  "none",
                borderRadius:
                  "8px",
              }}
            >
              {loading
                ? "Creating..."
                : "Create"}
            </Button>
          </Box>
        </Box>
      </Card>

      {/* Success Dialog */}
      <Dialog
        open={openDialog}
        onClose={() =>
          setOpenDialog(false)
        }
        maxWidth="xs"
        fullWidth
      >
        <DialogTitle>
          Voucher Request Created
        </DialogTitle>

        <DialogContent>
          <Typography mb={2}>
            Voucher ID
          </Typography>

          <Box
            sx={{
              display: "flex",
              alignItems:
                "center",
              justifyContent:
                "space-between",
              border:
                "1px solid #ccc",
              borderRadius: 2,
              px: 2,
              py: 1.5,
              background:
                "#f8f9fa",
            }}
          >
            <Typography
              fontWeight={700}
              color="primary"
            >
              {createdVID}
            </Typography>

            <IconButton
              onClick={() => {
                navigator.clipboard.writeText(
                  createdVID
                );

                setSnackbar({
                  open: true,
                  message:
                    "Voucher ID copied",
                  severity:
                    "success",
                });
              }}
            >
              <ContentCopyIcon />
            </IconButton>
          </Box>
        </DialogContent>

        <DialogActions
          sx={{
            p: 3,
            pt: 1,
          }}
        >
          <Button
            variant="outlined"
            onClick={() =>
              setOpenDialog(
                false
              )
            }
          >
            Create New Voucher
          </Button>

          <Button
            variant="contained"
            onClick={() => {
              setOpenDialog(
                false
              );

              setCurrentScreen(
                "view"
              );
            }}
          >
            View Requests
          </Button>
        </DialogActions>
      </Dialog>

      {/* Snackbar */}
      <Snackbar
        open={snackbar.open}
        autoHideDuration={
          3000
        }
        onClose={() =>
          setSnackbar(
            (prev) => ({
              ...prev,
              open: false,
            })
          )
        }
        anchorOrigin={{
          vertical: "top",
          horizontal:
            "right",
        }}
      >
        <Alert
          severity={
            snackbar.severity
          }
          variant="filled"
        >
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Box>
  );
};

export default RequestVoucherScreen;
