void wave_parm(float *  *  U_0_1_out, float *  U_0_m1, float *  U_0_0, float *  U_0_1, float fMin, float fDX, float fDT_DX_sq, int x_max, int y_max, int z_max, int cb_x, int cb_y, int cb_z, int chunk, int _unroll_p3);
void wave(float *  *  U_0_1_out, float *  U_0_m1, float *  U_0_0, float *  U_0_1, float fMin, float fDX, float fDT_DX_sq, int x_max, int y_max, int z_max);
void initialize_wave_parm(float *  U_0_m1, float *  U_0_0, float *  U_0_1, float fMin, float fDX, float fDT_DX_sq, int x_max, int y_max, int z_max, int cb_x, int cb_y, int cb_z, int chunk);
void initialize_wave(float *  U_0_m1, float *  U_0_0, float *  U_0_1, float fMin, float fDX, float fDT_DX_sq, int x_max, int y_max, int z_max);
