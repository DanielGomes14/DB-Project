﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace App
{
    public partial class PlatformDetails : Form
    {

        private string platform;
        public PlatformDetails(string platform)
        {
            this.platform = platform;
            InitializeComponent();
            LoadPlatformDetails();
        }

        private void LoadPlatformDetails()
        {

        }

        private void Close(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}