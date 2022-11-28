using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Seleplus.Scripts
{
    public class MouseTracker : MonoBehaviour
    {
        [Header("References")]
        [SerializeField] private CameraTracker target;

        public Vector2 worldPosition { get { return target.camera.ScreenToWorldPoint(new Vector3(Mouse.current.position.x.ReadValue(), Mouse.current.position.y.ReadValue(), -target.targetZ)); } }
    }
}
