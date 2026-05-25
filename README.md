// RequestVoucherScreen.jsx

import React, { useState } from "react";
import {
  Box,
  Button,
  Card,
  CardContent,
  FormControl,
  Grid,
  InputLabel,
  MenuItem,
  Select,
  Snackbar,
  Alert,
  TextField,
  Typography,
} from "@mui/material";

const voucherCategories = [
  "Payment",
  "Adjustment",
  "Reversal",
  "Refund",
  "Other",
];

const allowedRoles = [
  "Maker",
  "Checker",
  "Approver",
  "Admin",
];

const RequestVoucherScreen = () => {
  const [formData, setFormData] = useState({
    voucherCategory: "",
    otherCategory: "",
    description: "",
    allowedRole: "",
    sdRequestNumber: "",
  });

  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);

  const [snackbar, setSnackbar] = useState({
    open: false,
    message: "",
    severity: "success",
  });

  const handleChange = (e) => {
    const { name, value } = e.target;

    // SD Request Validation
    if (name === "sdRequestNumber") {
      const regex = /^[0-9,]*$/;

      if (!regex.test(value)) {
        return;
      }
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

    if (!formData.voucherCategory) {
      newErrors.voucherCategory = "Voucher Category is required";
    }

    if (
      formData.voucherCategory === "Other" &&
      !formData.otherCategory.trim()
    ) {
      newErrors.otherCategory = "Please enter category";
    }

    if (!formData.description.trim()) {
      newErrors.description = "Description is required";
    }

    if (!formData.allowedRole) {
      newErrors.allowedRole = "Allowed Role is required";
    }

    setErrors(newErrors);

    return Object.keys(newErrors).length === 0;
  };

  const generateVID = () => {
    const today = new Date();

    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, "0");

    const random = Math.floor(10000 + Math.random() * 90000);

    return `VID-${year}${month}-${random}`;
  };

  const handleCreate = async () => {
    if (!validateForm()) {
      return;
    }

    setLoading(true);

    try {
      // Mock API Delay
      await new Promise((resolve) => setTimeout(resolve, 1000));

      const payload = {
        ...formData,
        vid: generateVID(),
        status: "ACTIVE",
        createdDate: new Date().toISOString(),
      };

      console.log("Payload => ", payload);

      setSnackbar({
        open: true,
        message: `Voucher Request Created Successfully`,
        severity: "success",
      });

      // Reset Form
      setFormData({
        voucherCategory: "",
        otherCategory: "",
        description: "",
        allowedRole: "",
        sdRequestNumber: "",
      });
    } catch (error) {
      setSnackbar({
        open: true,
        message: "Something went wrong",
        severity: "error",
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box p={3}>
      <Card elevation={3}>
        <CardContent>
          <Typography variant="h5" fontWeight={600} mb={3}>
            Request Voucher
          </Typography>

          <Grid container spacing={3}>
            {/* Voucher Category */}
            <Grid item xs={12} md={6}>
              <FormControl fullWidth error={!!errors.voucherCategory}>
                <InputLabel>Voucher Category</InputLabel>

                <Select
                  name="voucherCategory"
                  value={formData.voucherCategory}
                  label="Voucher Category"
                  onChange={handleChange}
                >
                  {voucherCategories.map((category) => (
                    <MenuItem key={category} value={category}>
                      {category}
                    </MenuItem>
                  ))}
                </Select>

                {errors.voucherCategory && (
                  <Typography color="error" variant="caption">
                    {errors.voucherCategory}
                  </Typography>
                )}
              </FormControl>
            </Grid>

            {/* Other Category */}
            {formData.voucherCategory === "Other" && (
              <Grid item xs={12} md={6}>
                <TextField
                  fullWidth
                  label="Other Category"
                  name="otherCategory"
                  value={formData.otherCategory}
                  onChange={handleChange}
                  inputProps={{ maxLength: 20 }}
                  error={!!errors.otherCategory}
                  helperText={
                    errors.otherCategory ||
                    `${formData.otherCategory.length}/20`
                  }
                />
              </Grid>
            )}

            {/* Allowed Role */}
            <Grid item xs={12} md={6}>
              <FormControl fullWidth error={!!errors.allowedRole}>
                <InputLabel>Allowed Role</InputLabel>

                <Select
                  name="allowedRole"
                  value={formData.allowedRole}
                  label="Allowed Role"
                  onChange={handleChange}
                >
                  {allowedRoles.map((role) => (
                    <MenuItem key={role} value={role}>
                      {role}
                    </MenuItem>
                  ))}
                </Select>

                {errors.allowedRole && (
                  <Typography color="error" variant="caption">
                    {errors.allowedRole}
                  </Typography>
                )}
              </FormControl>
            </Grid>

            {/* SD Request Number */}
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="SD Request Number"
                name="sdRequestNumber"
                value={formData.sdRequestNumber}
                onChange={handleChange}
                helperText="Only numbers and commas allowed"
              />
            </Grid>

            {/* Description */}
            <Grid item xs={12}>
              <TextField
                fullWidth
                multiline
                rows={4}
                label="Description"
                name="description"
                value={formData.description}
                onChange={handleChange}
                inputProps={{ maxLength: 500 }}
                error={!!errors.description}
                helperText={
                  errors.description ||
                  `${formData.description.length}/500`
                }
              />
            </Grid>

            {/* Buttons */}
            <Grid item xs={12}>
              <Box display="flex" justifyContent="flex-end" gap={2}>
                <Button
                  variant="outlined"
                  onClick={() => {
                    setFormData({
                      voucherCategory: "",
                      otherCategory: "",
                      description: "",
                      allowedRole: "",
                      sdRequestNumber: "",
                    });

                    setErrors({});
                  }}
                >
                  Reset
                </Button>

                <Button
                  variant="contained"
                  onClick={handleCreate}
                  disabled={loading}
                >
                  {loading ? "Creating..." : "Create"}
                </Button>
              </Box>
            </Grid>
          </Grid>
        </CardContent>
      </Card>

      {/* Snackbar */}
      <Snackbar
        open={snackbar.open}
        autoHideDuration={3000}
        onClose={() =>
          setSnackbar((prev) => ({
            ...prev,
            open: false,
          }))
        }
        anchorOrigin={{
          vertical: "top",
          horizontal: "right",
        }}
      >
        <Alert severity={snackbar.severity} variant="filled">
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Box>
  );
};

export default RequestVoucherScreen;