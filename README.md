# CSM-input

`CSM-input` is a MATLAB script for reading and analysing Continuous Stiffness Measurement (CSM) nanoindentation maps from the Agilent G200 Nanoindenter. The output is a `.mat` file containing average hardness, modulus, and Nix-Gao fitting parameters: \( H_0 \) and \( h^* \).

This script is adapted from [C. Magazzani’s `XPInputDeck.m`](https://github.com/cmmagazz/XPressImport/blob/master/XPInputDeck.m), originally developed for Express Test data. I modified it to support **CSM test data** and compute **Nix-Gao parameters** by analysing binned displacement–hardness data.

## What the script does

- Reads CSM nanoindentation results from an Excel file organised in a grid.
- Calculates and stores:
  - Average **hardness** and **modulus** for each indent (within a displacement range).
  - Grid **coordinates** of each indent based on batch dimensions.
- Bins displacement–hardness data to smooth noise and applies a second-order polynomial fit to \( H^2 \) vs. \( 1/h \) (Nix-Gao model).
- Calculates:
  - \( H_0 \): Hardness extrapolated to infinite depth (from the tangent line's y-intercept).
  - \( h^* \): Characteristic length scale (from the tangent slope and \( H_0 \)).
- Returns:
  - `fullres`: a 3D array of `[avg_hardness, avg_modulus, H_0, h*]` per indent.
  - `fullresloc`: a 2D array with XY coordinates of each indent.

---

**Note**: This script assumes all indentation data is stored in a single Excel file with each sheet corresponding to a test site in a snaking grid layout (left-to-right on odd rows, right-to-left on even rows).
