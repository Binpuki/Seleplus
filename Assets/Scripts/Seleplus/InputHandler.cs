using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Seleplus
{
    public class InputHandler : MonoBehaviour
    {
        [SerializeField]
        private List<InputAction> inputs = new List<InputAction>();

        public void AddPressEvent(string key, Action<InputAction.CallbackContext> action, string name = null)
        {
            InputAction input = new InputAction(name, InputActionType.Button, key);
            input.performed += action;
            inputs.Add(input);
        }

        public void RemovePressEvent(string key, Action<InputAction.CallbackContext> action)
        {
            
        }

        public void AddReleaseEvent(string key, Action<InputAction.CallbackContext> action)
        {

        }

        public void RemoveReleaseEvent(string key, Action<InputAction.CallbackContext> action)
        {

        }
    }
}
