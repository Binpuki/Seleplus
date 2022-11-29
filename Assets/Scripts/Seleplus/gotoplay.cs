using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Seleplus
{
    public class gotoplay : MonoBehaviour
    {
        public void gotothing()
        {
            SceneManager.LoadScene("SampleScene");
        }
    }
}
