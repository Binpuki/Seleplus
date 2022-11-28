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

        private bool _inputsEnabled = false;
        public bool inputsEnabled { get { return _inputsEnabled; } set { _inputsEnabled = value; foreach (InputAction input in inputs) { if (_inputsEnabled) input.Enable(); else input.Disable(); } } }

        public void AddPressEvent(string name, string[] keys, Action<InputAction.CallbackContext> action)
        {
            InputAction input = inputs.FirstOrDefault(x => x.name == name);
            if (input == null)
            {
                input = new InputAction(name, InputActionType.Button);

                if (keys != null)
                    foreach (string key in keys)
                        input.AddBinding(key, "press(behavior=0)");

                inputs.Add(input);
            }

            input.performed += action;
        }

        public void RemovePressEvent(string name, Action<InputAction.CallbackContext> action)
        {
            InputAction input = inputs.FirstOrDefault(x => x.name == name);
            if (input == null)
                throw new Exception($"Input {name} does not exist! Can not remove press event.");

            input.performed -= action;
        }

        public void AddReleaseEvent(string name, string[] keys, Action<InputAction.CallbackContext> action)
        {
            InputAction input = inputs.FirstOrDefault(x => x.name == name);
            if (input == null)
            {
                input = new InputAction(name, InputActionType.Button);

                if (keys != null)
                    foreach (string key in keys)
                        input.AddBinding(key, "press(behavior=1)");

                inputs.Add(input);
            }

            input.performed += action;
        }

        public void RemoveReleaseEvent(string name, Action<InputAction.CallbackContext> action)
        {
            InputAction input = inputs.FirstOrDefault(x => x.name == name);
            if (input == null)
                throw new Exception($"Input {name} does not exist! Can not remove release event.");

            input.performed -= action;
        }
    }
}
