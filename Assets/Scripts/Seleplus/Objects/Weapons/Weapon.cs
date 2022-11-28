using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using Seleplus.Data;

namespace Seleplus.Objects.Weapons
{
    public class Weapon : InputHandler
    {
        public float Damage = 0.3f;
        public float Speed = 1f / 24f; // in seconds

        private Dictionary<string, bool> keysDown = new Dictionary<string, bool>();

        protected virtual void Awake()
        {
            ReloadKeybinds();
            inputsEnabled = true;
        }

        public void ReloadKeybinds()
        {
            string[] labels = { "Attack" };

            for (int i = 0; i < SaveData.Data.WeaponBinds.Length; i++)
            {
                if (!keysDown.ContainsKey(labels[i]))
                    keysDown[labels[i]] = false;

                string bullShit = labels[i];

                AddPressEvent($"{labels[i]} Pressed", new string[] { SaveData.Data.WeaponBinds[i] }, (a) => { keysDown[bullShit] = true; OnAttack(bullShit); });
                AddHoldEvent($"{labels[i]} Held", new string[] { SaveData.Data.WeaponBinds[i] }, Speed, (a) => { OnAttackHold(bullShit); });
                AddReleaseEvent($"{labels[i]} Released", new string[] { SaveData.Data.WeaponBinds[i] }, (a) => { keysDown[bullShit] = false; ReleaseAttack(bullShit); });
            }
        }

        protected virtual void Update() { }

        public virtual void OnAttack(string action) { }

        public virtual void OnAttackHold(string action) { }

        public virtual void ReleaseAttack(string action) { }
    }
}
