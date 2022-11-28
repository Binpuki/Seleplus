using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.InputSystem;
using Seleplus.Scripts;

namespace Seleplus.Objects.Weapons
{
    public class RangedWeapon : MonoBehaviour
    {
        public SpriteRenderer spriteRenderer;
        public Transform gunBarrel;
        private MouseTracker mouseTracker;

        public Transform center;
        public float radius = 1f;

        public bool flipX;
        private void Start()
        {
            mouseTracker = FindObjectOfType<MouseTracker>();
            flipX = spriteRenderer.flipX;
        }

        private void Update()
        {
            // I KNOW THIS IS BAD BUT IT WORKS FOR NOW, I WILL REWORK LATER ;-;
            Vector2 mouseCalc = new Vector2(mouseTracker.worldPosition.x - gunBarrel.position.x, mouseTracker.worldPosition.y - gunBarrel.position.y);

            float angle = (Mathf.Atan2(mouseCalc.y, mouseCalc.x));
            float angleDegrees = angle * (180f / Mathf.PI);
            transform.position = new Vector3(center.position.x + (radius * Mathf.Cos(angle)), center.position.y + (radius * Mathf.Sin(angle)), center.position.z);

            Quaternion rotation = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y, angleDegrees);
            Debug.Log(rotation.z);
            bool reached90 = (rotation.eulerAngles.z > 90f && rotation.eulerAngles.z < 270f);
            spriteRenderer.flipX = (!flipX ? reached90 : !reached90);

            if (reached90)
                rotation = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y, angleDegrees - 180);

            transform.rotation = rotation;
        }
    }
}
