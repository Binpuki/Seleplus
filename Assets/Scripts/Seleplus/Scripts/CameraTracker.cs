using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Seleplus.Scripts
{
    public class CameraTracker : MonoBehaviour
    {
        public float targetZ = 0f;

        public Camera camera;
        public Transform target;

        private void Update()
        {
            camera.transform.position = new Vector3(target.position.x, target.position.y, targetZ);
        }
    }
}
