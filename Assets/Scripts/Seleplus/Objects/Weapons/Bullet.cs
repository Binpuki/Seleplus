using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Seleplus.Objects.Weapons
{
    public class Bullet : MonoBehaviour
    {
        public float speed;
        public List<LayerMask> layerCollisions = new List<LayerMask>();

        [SerializeField] private float hypotenuse;
        [SerializeField] private Vector2 direction;

        public void Setup(Vector2 startingPoint, Vector2 destinationPoint, float angleDegrees)
        {
            transform.position = startingPoint;
            transform.rotation = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y, angleDegrees);

            Vector2 center = new Vector2(destinationPoint.x - startingPoint.x, destinationPoint.y - startingPoint.y);

            hypotenuse = Mathf.Sqrt(Mathf.Pow(center.x, 2) + Mathf.Pow(center.y, 2));
            direction = new Vector2(center.x / (hypotenuse / speed), center.y / (hypotenuse / speed));
        }

        //public void 

        private void FixedUpdate()
        {
            transform.position = new Vector3(transform.position.x + direction.x, transform.position.y + direction.y);
        }
    }
}
